Developer's guide to Thoth
--------------------------

This document is from series of documents about project Thoth. The main goal of this document is to give a first touch on how to run, develop and use Thoth as a developer.

A prerequisite for this document are the following documents:

* `General Thoth overview <https://github.com/thoth-station/thoth/blob/master/README.rst>`_
* `Basic usage of Pipenv <https://pipenv.readthedocs.io/en/latest/basics/>`_
* Basics of OpenShift - see for example `Basic Walkthrough <https://docs.openshift.com/online/getting_started/basic_walkthrough.html>`_


Preparing Developer's Environment
=================================

Use Ansible script `git-clone-repos.yaml` present in the `Core repository <https://github.com/thoth-station/core/blob/master/git-clone-repos.yaml>`_ and follow instructions present on the `following page <https://url.corp.redhat.com/clone-thoth>`_.


Once you finish cloning the GitHub repositories, the directory structure in your desired directory should state all the active repositories under the Thoth-Station organization on GitHub:

.. code-block:: console

  $ ls -A1 thoth-station/
  adviser
  amun-api
  amun-client
  amun-hwinfo
  analyzer
  ...
  user-api
  workload-operator
  zuul-test-config
  zuul-test-jobs

These all are the repositories cloned to the most recent master branch (see also `git-update-repos.yaml` Ansible script to update repositories after some time).

Using Pipenv
============

All of the Thoth packages use `Pipenv` to create a separated and reproducible environment in which the given component can run. Almost every repository has its own ``Pipfile`` and ``Pipfile.lock`` file. The ``Pipfile`` file states direct dependencies for a project and ``Pipfile.lock`` file states all the dependencies (including the transitive ones) pinned to a specific version.

If you have cloned the repositories via the provided Ansible script, the Ansible scripts prepares the environment for you. It runs the following command to prepare a separate virtual environment with all the dependencies (including the transitive ones):

.. code-block:: console

  $ pipenv install --dev

As the environment is separated for each and every repository, you can now switch between environments that can have different versions of packages installed.

If you would like to install some additional libraries, just issue:

.. code-block:: console

  $ pipenv install <name-of-a-package>   # Add --dev if it is a devel dependency.

The ``Pipfile`` and ``Pipfile.lock`` file get updated.

If you would like to run a CLI provided by a repository, issue the following command:

.. code-block:: console

  # Run adviser CLI inside adviser/ repository:
  $ cd adviser/
  $ pipenv run ./thoth-adviser --help

The command above automatically activates separated virtual environment created for the thoth-adviser and uses packages from there.

To activate virtual environment permanently, issue:

.. code-block:: console

  $ pipenv shell
  (adviser)$

Your shell prompt will change (showing that you are inside a virtual environment) and you can run for example Python interpret to run some of the Python code provided:

.. code-block:: console

  (adviser)$ python3
  >>> from thoth.adviser import __version__
  >>> print(__version__)


Developing cross-library features
=================================

As Thoth is created by multiple libraries which depend on each other, it is often desired to test some of the functionality provided by one library inside another.

Suppose you would like to run adviser with a different version of ``thoth-python`` package (present in the ``python/ directory``). To do so, the only thing you need to perform is to run the thoth-adviser CLI (in ``adviser`` repo) in the following way:


.. code-block:: console

  $ cd adviser/
  $ PYTHONPATH=../python pipenv run ./thoth-adviser provenance --requirements ./Pipfile --requirements-locked ./Pipfile.lock --files

The ``PYTHONPATH`` environment variable tells Python interpret to search for sources first in the ``../python`` directory, this makes the following code:


.. code-block:: python

  from thoth.python import __version__

to first check sources present in ``../python`` and run code from there (instead of running the installed ``thoth-python`` package from PyPI inside virtual environment).

If you would like to run multiple libraries this way, you need to delimit them using a colon:

.. code-block:: console

  $ cd adviser/
  $ PYTHONPATH=../python:../common pipenv run ./thoth-adviser --help


Testing application against Ceph and graph database
===================================================

If you would like test changes in your application against data stored inside Ceph, you can use the following command (if you have your ``gopass`` set up):

.. code-block:: console

  $ eval $(gopass show aicoe/thoth/ceph.sh)

This will inject into your environment Ceph configuration needed for adapters available in ``thoth-storages`` package and you can talk to Ceph instance.

In most cases you will need to set ``THOTH_DEPLOYMENT_NAME`` environment variable which distinguishes different deployments.

.. code-block:: console

  $ export THOTH_DEPLOYMENT_NAME=thoth-test-core

To browse data stored on Ceph, you can use ``awscli`` from `PyPI <https://pypi.org/project/awscli/>`_ utility which provides ``aws`` command (use ``aws s3`` as Ceph exposes S3 compatible API).

To run applications against a graph database, export the following environment variables:

.. code-block:: console

  $ export JANUSGRAPH_SERVICE_HOST=test-3.janusgraph.thoth-station.ninja

If the JanusGraph is serving requests on different port (not usual in Thoth deployments), you can specify also port by exporting:

.. code-block:: console

  # Default port on which JanusGraph instances listen on:
  $ export JANUSGRAPH_SERVICE_PORT=8182

Running application inside OpenShift vs local development
=========================================================

All the libraries are designed to run locally (for fast developer's experience - iterating over features as fast as possible) as well as to run them inside a cluster.

If a library uses OpenShift's API (such as all the operators), the ``OpenShift`` class implemented in ``thoth-common`` library takes care of transparent discovery whether you run in the cluster or locally. If you would like to run applications against OpenShift cluster from your local development environment, use ``oc`` command to login into the cluster and change to project where you would like to operate in:

.. code-block:: console

  $ oc login <openshift-cluster-url>
  ...
  $ oc project thoth-test-core

And run your applications (the configuration on how to talk to the cluster is picked from OpenShift's/Kubernetes config). You should see a courtesy warning by ``thoth-common`` that you are running your application locally.

To run an application from sources present in the local directory (for example with changes you have made), you can use the following command to upload sources to OpenShift and start a build:

.. code-block:: console

  $ cd adviser/
  $ oc start-build adviser --from-dir=. -n <namespace>

You will see (for example in the OpenShift console) that the build was triggered from sources.

To see available builds (that match component name), issue the following once you are logged in and present in the right project:

.. code-block:: console

  $ oc get builds