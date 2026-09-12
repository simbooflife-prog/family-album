.PHONY: verify checksums

# Local checksums for deploy notes (frame.html + week.json)
verify checksums:
	@./scripts/verify-local.sh
