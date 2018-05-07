from fabric.api import run
from fabric.context_managers import cd


def build():
    """
    Run the OVA build on remote host with Fabric.

    :return:
    """
    with cd('/home/ova'):
        run('make build')
