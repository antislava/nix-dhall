DIR = .
DHALL = $(DIR)/dhall-haskell
DH_LATEST = $(DHALL)/github.release.latest

.PHONY : shell-dev
shell-dev :
	nix-shell -p jq shab

.PHONY : shell-test
shell-test :
	nix-shell ./test-shell.nix

.PHONY : shell-test-pure
shell-test-pure :
	nix-shell ./test-shell.nix --pure

$(DH_LATEST).json : $(DH_LATEST).sh
	sh $< > $@

$(DH_LATEST).prefetched.json : $(DH_LATEST).json $(DHALL)/prefetch-assets.nix
	nix eval "(import $(DHALL)/prefetch-assets.nix)" --json | shab | jq -r > $@

# .PHONY : $(DH_LATEST).print-asset-names
$(DH_LATEST).print-asset-names :
%.print-asset-names : %.json
	jq .assets[].name < $<

# OLD (but kept for the time being...)
# Switched from jq (below) to nix eval for better consistency
# $(SRC_URL)/%.github.release.linux.json : $(SRC_URL)/%.github.release.json
# 	jq '{ name, tag_name, created_at, "assets": [ .assets[] | select(.name | contains("linux") and contains("tar")) | { name, url: .browser_download_url, sha256: ("$$(nix-prefetch-url " + .browser_download_url +")") } ] }' $< | shab > $@
