# Class: typo3_flow
#
# This module manages typo3_flow
#
# Parameters:
#
# [*mange_composer*]
#   Managed whether composer should be installed or not
#   Default: true
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class typo3_flow ($mange_composer = true) {
  validate_bool($mange_composer)
  if ($mange_composer) {
    include ::composer
  }
}
