from fabric.api import run
from fabric.context_managers import cd


def build(license_key):
    """
    Run the OVA build on remote host with Fabric.

    :param license_key: Required StackStorm Enterprise license key.
    :return:
    """
    with cd('/home/ova'):
        run('make build')
