# Cloud Armor WAF policy for the public Dragonfly workshop.
#
# Documentation:
# https://cloud.google.com/armor/docs/waf-rules
# https://cloud.google.com/armor/docs/rule-tuning
# https://cloud.google.com/armor/docs/request-logging
#
# Enforcement:
# - All documented CRS 4.22 rule families are enabled.
# - Sensitivity 4 includes signatures at levels 1 through 4.
# - Every matching WAF rule immediately denies the request with HTTP 403.
# - No signatures are excluded.
# - The default rule allows anonymous workshop access after WAF evaluation.
#
# Troubleshooting:
# Lower priority numbers are evaluated first.
# Each rule family has its own priority for easier investigation.
#
# Logs Explorer filter:
# jsonPayload.enforcedSecurityPolicy.outcome="DENY"
#
# Inspect:
# jsonPayload.enforcedSecurityPolicy.priority
# jsonPayload.enforcedSecurityPolicy.preconfiguredExprIds
#
# Backend service request logging must also be enabled.
# Check the project's current Cloud Armor quotas before applying.

locals {
  security-policy-project     = google_compute_network.gcp_vpc_network.project
  security-policy-name        = "${google_compute_network.gcp_vpc_network.name}-security-policy"
  security-policy-description = "Dragonfly workshop WAF with full CRS 4.22 signature coverage"
}

resource "google_compute_security_policy" "cloud-armor-security-policy" {
  project     = local.security-policy-project
  name        = local.security-policy-name
  description = local.security-policy-description

  # Configure request-body inspection for the WAF.
  advanced_options_config {
    # Inspect JSON request bodies using their parsed structure.
    json_parsing = "STANDARD"

    # Keep normal security logging. Verbose logging can include matched
    # request content and should be enabled deliberately for diagnostics.
    log_level = "NORMAL"
  }

  # SQL injection.
  rule {
    description = "Block SQL injection signatures at sensitivity 4"
    action      = "deny(403)"
    priority    = 1000
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('sqli-v422-stable', {'sensitivity': 4})"
      }
    }
  }

  # Cross-site scripting.
  rule {
    description = "Block cross-site scripting signatures at sensitivity 4"
    action      = "deny(403)"
    priority    = 1010
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('xss-v422-stable', {'sensitivity': 4})"
      }
    }
  }

  # Local file inclusion and path traversal.
  rule {
    description = "Block local file inclusion signatures at sensitivity 4"
    action      = "deny(403)"
    priority    = 1020
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('lfi-v422-stable', {'sensitivity': 4})"
      }
    }
  }

  # Remote file inclusion.
  rule {
    description = "Block remote file inclusion signatures at sensitivity 4"
    action      = "deny(403)"
    priority    = 1030
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('rfi-v422-stable', {'sensitivity': 4})"
      }
    }
  }

  # Remote code execution.
  rule {
    description = "Block remote code execution signatures at sensitivity 4"
    action      = "deny(403)"
    priority    = 1040
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('rce-v422-stable', {'sensitivity': 4})"
      }
    }
  }

  # HTTP protocol attacks.
  rule {
    description = "Block protocol attack signatures at sensitivity 4"
    action      = "deny(403)"
    priority    = 1050
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('protocolattack-v422-stable', {'sensitivity': 4})"
      }
    }
  }

  # PHP injection attacks.
  rule {
    description = "Block PHP attack signatures at sensitivity 4"
    action      = "deny(403)"
    priority    = 1060
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('php-v422-stable', {'sensitivity': 4})"
      }
    }
  }

  # Session fixation.
  rule {
    description = "Block session fixation signatures at sensitivity 4"
    action      = "deny(403)"
    priority    = 1070
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('sessionfixation-v422-stable', {'sensitivity': 4})"
      }
    }
  }

  # Java attack signatures are included for complete CRS family coverage.
  rule {
    description = "Block Java attack signatures at sensitivity 4"
    action      = "deny(403)"
    priority    = 1080
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('java-v422-stable', {'sensitivity': 4})"
      }
    }
  }

  # CRS 4.22 uses the generic family for coverage previously associated
  # with the Node.js family, together with additional generic signatures.
  rule {
    description = "Block generic attack signatures at sensitivity 4"
    action      = "deny(403)"
    priority    = 1090
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('generic-v422-stable', {'sensitivity': 4})"
      }
    }
  }

  # Apply the method policy implemented by the preconfigured ruleset.
  rule {
    description = "Block method enforcement signatures at sensitivity 4"
    action      = "deny(403)"
    priority    = 1100
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('methodenforcement-v422-stable', {'sensitivity': 4})"
      }
    }
  }

  # These signatures can match authorized scanners and generic HTTP clients.
  # Include workshop tools and DAST scanners in functional testing.
  rule {
    description = "Block scanner detection signatures at sensitivity 4"
    action      = "deny(403)"
    priority    = 1110
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('scannerdetection-v422-stable', {'sensitivity': 4})"
      }
    }
  }

  # Google's separately maintained CVE rules include Log4Shell protection.
  #
  # Omitting the optional parameter map uses the default sensitivity 4.
  # Keep this standalone expression so Checkov CKV_GCP_73 can recognize
  # the enforced protection.
  rule {
    description = "Block all signatures in Google's CVE ruleset"
    action      = "deny(403)"
    priority    = 1120
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('cve-canary')"
      }
    }
  }

  # Enable the documented JSON SQL injection signature.
  # Sensitivity 0 begins with an empty set; opt_in_rule_ids selects it.
  rule {
    description = "Block the JSON SQL injection signature"
    action      = "deny(403)"
    priority    = 1130
    preview     = false

    match {
      expr {
        expression = "evaluatePreconfiguredWaf('json-sqli-canary', {'sensitivity': 0, 'opt_in_rule_ids': ['owasp-crs-id942550-sqli']})"
      }
    }
  }

  # Dragonfly intentionally accepts anonymous workshop attendees.
  # This mandatory final rule allows requests that passed the WAF checks.
  rule {
    description = "Allow requests that did not match an earlier blocking rule"
    action      = "allow"
    priority    = 2147483647
    preview     = false

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}