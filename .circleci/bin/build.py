import os
from fabric.api import run
from fabric.context_managers import cd, shell_env


def build():
    """
    Run the Packer build on remote host with Fabric.

    Bypass 'ST2_VERSION' and 'BOX_VERSION' ENV vars.

    :return:
    """
    with cd('/home/ova'):
        with shell_env(ST2_VERSION=os.environ.get('ST2_VERSION'),
                       BOX_VERSION=os.environ.get('BOX_VERSION')):
            run('make build')
