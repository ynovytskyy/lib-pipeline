#!/bin/bash
set -eux

git clone source release-source

pushd release-source
    git config user.email "concourse@noreply.com"
    git config user.name "concourse"

    mvn versions:set -DremoveSnapshot=true
    mvn clean package #deploy

    RELEASE_VERSION=`mvn -q -Dexec.executable="echo" -Dexec.args='${project.version}' --non-recursive exec:exec`
    git add pom.xml
    git commit -m "[ci skip] Setting pom.xml version for release to ${RELEASE_VERSION}"
    git tag "${RELEASE_VERSION}"

    VERSIONS_PLUGIN=org.codehaus.mojo:versions-maven-plugin:2.5
    # Apply SNAPSHOT and increment the patch version.
    # This first nextSnapshot command simply applies a snapshot with the same version and is a
    # workaround for https://github.com/mojohaus/versions-maven-plugin/issues/207
    # TODO Remove this first nextSnapshot command when versions-maven-plugin:2.6 is released and used
    mvn --quiet --batch-mode $VERSIONS_PLUGIN:set -DnextSnapshot=true -DnewVersion=$RELEASE_VERSION"-SNAPSHOT"
    mvn --quiet --batch-mode $VERSIONS_PLUGIN:set -DnextSnapshot=true

    NEXT_SNAPSHOT_VERSION=`mvn -q -Dexec.executable="echo" -Dexec.args='${project.version}' --non-recursive exec:exec`
    git add pom.xml
    git commit -m "[ci skip] Bump version in pom.xml for next development iteration to ${NEXT_SNAPSHOT_VERSION}"
popd
