Thoth
=====

There has been seen a hype over the past years in AI and machine learning.
Machine learning and AI applications are used in production systems which
require significant effort to ensure applications behave correctly and are
fully operational. Thoth is a recommendation system for (not only) AI and
machine learning applications which use popular open source machine learning
libraries. Thoth is capable of storing observations based on which it
predicts possible misbehavior in application, application assembling errors or
issues when integrating application with other components in a deployment.

Why Thoth?
##########

Every developer is struggling with choosing the right version of libraries
when developing an application. You might be asking - should I use version X
instead of Y? What happens if I choose version Y? What indirect dependencies
will be included in my application stack during resolving?

Moreover, development of an application is not the only phase in an
application lifecycle. You can easily struggle with updates - will an update
break my application? Should I update because of features or bug fixes in the
newly released dependency? Will my application break? Why should I update?

A good practice for having as much reproducible and working builds as
possible is to lock (or pin down) libraries which are used by application to
specific and required versions at the same time. Thoth is pushing this idea
further and instead of pinning down to the latest version of libraries where
possible (as Pipenv or pip does) it choses the best libraries in the specific
versions for your application based on aggregated knowledge. You can imagine
Thoth being a fine-tuned resolver that can come up with better version
pinning and recommendations for your applications based on observations
available in Thoth's database for your application which runs in a specific
runtime environment.

Imagine the following application consisting of Flask, gunicorn, TensorFlow
and Pandas. As you can see on the figure below, dependencies do not create
separate subgraphs. This causes that an update/downgrade of any
dependency (eigher direct or indirect) causes changes in the whole
application which can lead to misbehavior or (in better cases) fails with
application run.

.. figure:: https://raw.githubusercontent.com/thoth-station/thoth/master/fig/dependencies.png
   :alt: Interaction of application dependencies.
   :align: center


Zen of Thoth
############

1. Bots are our cyborg team members.
2. Python and machine learning is our first class citizen.
3. Stateless architecture, if state is needed we use Ceph, OpenShift's internal state available through API and graph database for advanced graph traversal based queries.
4. Reuse what has been previously invented.
5. Errors should never pass silently.
6. Clean design with clean Pythonic code counts.
7. Use Ansible for always-ready midnight deployment.
8. Self-living system with minimal operational overhead.
9. Never say immidiate no and never say immidiate yes to any new idea.
10. Be always open.

I want to become a Thoth contributor
####################################

If you would like to contirbute in the source code, you can check
`all the components of Thoth <https://github.com/thoth-station/>`_.
Most of the componentsare designed to have a command line interface (such as
solver, package-extract, ...) for easy development and when plugged to an
OpenShift cluster, they can easily scale baesd on Thoth's design.

If you would like to deploy Thoth, see the 
`core repository <https://github.com/thoth-station/core>`_ where
deploymnet playbooks live with their step-by-step documentation on how to
deploy Thoth into your OpenShift cluster (or to your local `oc cluster up`
instance).

Game of Gods
############

Thoth is actually one of the gods living in the
`thoth-station <https://github.com/thoth-station/>`_. You can find other gods
(named based on Egyptian mythology) that, together with Thoth, create their
own universe. In this universe however, gods do not fight against each other.
Insead, they create a pieceful co-operational ecosystem.

Currently available Gods
#########################

* `Thoth <https://github.com/thoth-station/core>`_ - the recommender system, holding knowledge based on which it creates advises

* `Sesheta <https://github.com/thoth-station/sesheta>`_ - bot that is responsible for automated PR merges, gathering information about CI runs on new pull requests or automatically labeling new issues and pull requests

* `Kebechet <https://github.com/thoth-station/kebechet>`_ - bot that is responsible for monitoring repositories, issuing pull-requests on new dependency releases, automatically issuing new releases on `PyPI <https://pypi.org>`_, and more

* `Amun <https://github.com/thoth-station/amun-api>`_ - system which is the execution part of Thoth, it is capable of creating runtime environments based on specification, creating application stack and executing necessary tests (such as application, performance, ...) to gather observations for Thoth's database

* `Nepthys <https://github.com/thoth-station/nepthys>`_ - a bot responsible for automatic documentation updates
 
See `thoth-station organization <https://github.com/thoth-station/>`_ on
GitHub for more information.