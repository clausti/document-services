# The Climate Corporation licenses this file to you under under the Apache
# License, Version 2.0 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.  Unless required by applicable law or agreed
# to in writing, software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied.  See the License for the specific language governing permissions
# and limitations under the License.
require 'rails_helper'

RSpec.describe "templates/show", type: :view do
  let(:template) { create(:template, :single) }
  let!(:template_version) { create(:template_single_version, template: template) }

  before { assign(:template, template) }

  it "renders the template attributes" do
    render

    expect(rendered).to include(template.name)
    expect(rendered).to include(template.created_by)
    expect(rendered).to include(template.created_at.to_formatted_s)
    expect(rendered).to include(template.updated_at.to_formatted_s)
  end

  it "renders a list of template versions" do
    render

    assert_select 'td', text: "Version #{template_version.version}"
    assert_select 'td', text: template_version.created_by
    assert_select 'td', text: template_version.created_at.to_formatted_s
    assert_select 'td', text: template_version.template_schema.id
    assert_select 'td', text: template_version.ready_for_production?
  end

  it "renders a button to enable or disable the template" do
    render

    assert_select 'a[href=?]', template_version_permissions_path(
      template, template_version.version, ready_for_production: !template_version.ready_for_production?)
  end

  it "renders a link to create a template version" do
    render

    assert_select 'a[href=?]', new_template_version_path(template)
  end

  it "renders a link to view the templates list" do
    render
    assert_select "a[href=?]", templates_path
  end

end
