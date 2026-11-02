-- SonarLint (SonarQube) inline diagnostics
-- First run: :SonarQubeInstallLsp (downloads the sonarlint-language-server into stdpath("data")/sonarqube)
require("sonarqube").setup({
    java = { await_jdtls = false },
})
