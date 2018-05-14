import os
from fabric.api import run
from fabric.context_managers import cd, shell_env


def pass_env(*args):
    """
    By-pass non-empty ENV variables with their values for the input list.

    :param args: List of ENV variables to include
    :type args: ``list``
    :return: ENV variables with values to bypass
    :rtype: ``dict``
    """
    return {k: v for k,v in os.environ.items() if k in args and v is not ''}


def build():
    """
    Run the Packer build on remote host with Fabric.
    Bypass local ENV vars 'ST2_VERSION' and 'BOX_VERSION' to remote host.
    """
    with cd('/home/ova'):
        with shell_env(**pass_env('ST2_VERSION', 'BOX_VERSION')):
            run('make build')
