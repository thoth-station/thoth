from setuptools import setup
from distutils.command.install import install as DistutilsInstall


class ThothInstall(DistutilsInstall):
    def run(self):
        raise NotImplementedError("Please use subpackages for interacting with Thoth")


setup(
    name='thoth',
    version='0.0.1',
    description='Thoth project',
    long_description='Thoth project',
    author='Fridolin Pokorny',
    author_email='fridolin@redhat.com',
    license='GPLv2+',
    packages=['thoth'],
    zip_safe=False,
    cmdclass={'install': ThothInstall}
)
