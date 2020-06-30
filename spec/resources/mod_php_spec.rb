require 'spec_helper'

describe 'apache2_mod_php' do
  step_into :apache2_install, :apache2_mod_php, :apache2_module
  default_attributes['php']['version'] = '7.2.31'

  platform 'ubuntu'

  context 'Setup and enable php module' do
    recipe do
      apache2_install 'phptest'
      apache2_mod_php 'phptest'
    end

    before do
      stub_command('/usr/sbin/apache2ctl -t').and_return('foo')
    end

    it do
      is_expected.to create_template('/etc/apache2/mods-available/php.conf')
    end

    it do
      is_expected.to create_link('/etc/apache2/mods-enabled/php.conf').with(
        to: '/etc/apache2/mods-available/php.conf'
      )
    end

    it do
      is_expected.to create_directory('/var/lib/php/session').with(
        owner: 'root',
        group: 'www-data',
        mode: '770'
      )
    end

    it do
      is_expected.to enable_apache2_module('php7').with(
        identifier: 'php7_module',
        mod_name: 'libphp7.so'
      )
    end
  end
end
