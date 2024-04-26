package e2e

import (
	"regexp"
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestExampleshub_w_force_tunnel_and_ddos(t *testing.T) {
	test_helper.RunE2ETest(t, "../../", "examples/commerical/hub_w_force_tunnel_and_ddos", terraform.Options{
		Upgrade: true,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		gotEchoText, ok := output["resource_group_name"].(string)
		assert.True(t, ok)
		assert.Regexp(t, regexp.MustCompile("an1-eus-hub-dev-rg"), gotEchoText)
	})
}
