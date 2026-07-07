SHELL := /bin/bash

NAME=mender
VERSION=$$(grep version: $(NAME)/Chart.yaml | sed -e 's/.*: *//g' | sed -e 's/"//g')

# Fetch the 5 most recent non-EOL Kubernetes minor versions at runtime.
# Requires curl and jq. For offline use, set KUBE_VERSIONS explicitly:
#   make kubeconform KUBE_VERSIONS="1.33.0 1.34.0 1.35.0"
KUBE_VERSIONS_CMD = TODAY=$$(date +%Y-%m-%d); \
	KUBE_VERSIONS=$$(curl -sf https://endoflife.date/api/kubernetes.json \
		| jq -r --arg today "$$TODAY" \
			'[.[] | select(.eol == false or .eol > $$today) | .cycle] \
			 | sort | reverse | .[0:5] | reverse | .[] | . + ".0"')

help: ## Show this help
	@IFS=$$'\n' ; \
		help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
		for help_line in $${help_lines[@]}; do \
				IFS=$$'#' ; \
				help_split=($$help_line) ; \
				help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
				help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
				printf "%-30s %s\n" $$help_command $$help_info ; \
		done

.PHONY: clean
clean: ## Clean the working directory removing the packages and the rendered templates
	rm -fr $(NAME)-$(VERSION)*.tgz $(NAME)-$(VERSION)*.yaml index.yaml tmp.*

.PHONY: lint
lint: ## Lint the mender helm package
	helm lint -f examples/values-mender.yaml $(NAME)

.PHONY: package
package: ## Create the mender helm package
	helm package $(NAME)
	helm repo index --url https://charts.mender.io .

.PHONY: upload
upload: package ## Upload the mender helm package to the charts repository
	curl --data-binary "@$(NAME)-$(VERSION).tgz" http://charts.mender.io/api/charts

.PHONY: template
template: ## Render the mender helm chart template
	helm template $(NAME)/ -f values-enterprise.yaml > $(NAME)-$(VERSION).yaml

.PHONY: unittest
unittest: ## Run helm unit tests
	helm unittest $(NAME)/

.PHONY: test
test: ## Run integration tests
	bash tests/tests.sh

.PHONY: test-all
test-all: lint unittest kubeconform check-deprecated-apis test ## Run all tests (lint, unit, kubeconform, deprecated-api, integration)

.PHONY: kubeconform
kubeconform: ## Run kubeconform over helm chart rendered template (versions from endoflife.date)
	$(KUBE_VERSIONS_CMD); \
	echo "INFO - versions: $$KUBE_VERSIONS"; \
	for kubeversion in $$KUBE_VERSIONS; do \
		helm template $(NAME)/ -f tests/values-helmci.yaml --kube-version $$kubeversion \
			| kubeconform --kubernetes-version $$kubeversion --strict --ignore-missing-schemas; \
	done

.PHONY: check-deprecated-apis
check-deprecated-apis: ## Detect removed/deprecated Kubernetes API versions (versions from endoflife.date)
	$(KUBE_VERSIONS_CMD); \
	echo "INFO - versions: $$KUBE_VERSIONS"; \
	for kubeversion in $$KUBE_VERSIONS; do \
		echo "INFO - checking deprecated APIs for k8s $$kubeversion"; \
		helm template $(NAME)/ -f tests/values-helmci.yaml --kube-version $$kubeversion \
			| pluto detect - --target-versions k8s=v$$kubeversion; \
	done

.PHONY: trivy
trivy: ## Run trivy misconfiguration check on the chart
	trivy config $(NAME)/ \
		--helm-values tests/values-helmci.yaml \
		--severity HIGH,CRITICAL \
		--exit-code 1 \
		--ignorefile .trivyignore

.PHONY: trivy-sbom
trivy-sbom: ## Generate CycloneDX SBOM by scanning all container images referenced in the chart
	rm -rf /tmp/trivy-sbom-parts && mkdir -p /tmp/trivy-sbom-parts; \
	IMAGES=$$(helm template $(NAME)/ -f tests/values-helmci.yaml \
		| grep -E '^\s+image: ' | awk '{print $$2}' | tr -d '"' | sort -u); \
	echo "INFO - images: $$(echo $$IMAGES | tr '\n' ' ')"; \
	for img in $$IMAGES; do \
		echo "INFO - scanning $$img"; \
		safe=$$(echo "$$img" | tr '/: ' '---'); \
		trivy image "$$img" --format cyclonedx --quiet \
			--output /tmp/trivy-sbom-parts/$$safe.json || \
			echo "WARN - failed to scan $$img (skipping)"; \
	done; \
	jq -s '{"bomFormat":"CycloneDX","specVersion":"1.5","version":1,"components":[.[].components//[]|.[]]}' \
		/tmp/trivy-sbom-parts/*.json > sbom.cdx.json; \
	echo "INFO - SBOM written to sbom.cdx.json ($$(jq '.components|length' sbom.cdx.json) components)"; \
	rm -rf /tmp/trivy-sbom-parts

.PHONY: template_helm_chart_previous_lts
template_helm_chart_previous_lts: ## Run the template of the previous LTS
	helm template mender/mender \
		--debug \
		-f mender/values.yaml \
		-f tests/keys.yaml \
		-f tests/values-helmci.yaml \
		--set global.image.tag="mender-3.6.5" \
    --set global.image.username=nt_fakeuser \
    --set global.image.password=nt_fakepassword \
    --set global.s3.AWS_ACCESS_KEY_ID="fakeaccesskey" \
    --set global.s3.AWS_SECRET_ACCESS_KEY="fakesecretkey" \
		--version 5.0.1

.PHONY: template_helm_chart_current_lts
template_helm_chart_current_lts: ## Run the template of the current LTS
	helm template ${NAME}/ \
		-f mender/values.yaml \
		-f tests/keys.yaml \
		-f tests/values-helmci.yaml \
		--set global.image.tag="mender-3.7.7" \
    --set global.image.username=nt_fakeuser \
    --set global.image.password=nt_fakepassword \
    --set global.s3.AWS_ACCESS_KEY_ID="fakeaccesskey" \
    --set global.s3.AWS_SECRET_ACCESS_KEY="fakesecretkey"
