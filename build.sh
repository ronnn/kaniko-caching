
echo "{\"auths\":{\"$REGISTRY\":{\"username\":\"serviceaccount\",\"password\":\"$REGISTRY_TOKEN\"}}}" > /kaniko/.docker/config.json

log_level="info"

/kaniko/executor version

# Create build image
echo $(date) > /app/date.txt
/kaniko/executor \
  --context "/app" \
  --dockerfile "/app/Dockerfile_build" \
  --skip-tls-verify-registry $REGISTRY \
  --destination "${REGISTRY}/${NAMESPACE}/cache-debug-build" \
  --cache-repo "${REGISTRY}/${NAMESPACE}/cache" \
  --cache=true \
  --cleanup \
  -v $log_level

# Create first image
date_tag="test-$(date +%s)"
/kaniko/executor \
  --context "/app" \
  --dockerfile "/app/Dockerfile_release" \
  --skip-tls-verify-registry $REGISTRY \
  --destination "${REGISTRY}/${NAMESPACE}/${date_tag}" \
  --cache-repo "${REGISTRY}/${NAMESPACE}/cache" \
  --cache=true \
  --cleanup \
  --build-arg from="${REGISTRY}/${NAMESPACE}/cache-debug-build" \
  --build-arg base="${REGISTRY}/${NAMESPACE}/alpine:3.11" \
  -v $log_level

# Create build image
echo $(date) > /app/date.txt
/kaniko/executor \
  --context "/app" \
  --dockerfile "/app/Dockerfile_build" \
  --skip-tls-verify-registry $REGISTRY \
  --destination "${REGISTRY}/${NAMESPACE}/cache-debug-build" \
  --cache-repo "${REGISTRY}/${NAMESPACE}/cache" \
  --cache=true \
  --cleanup \
  -v $log_level

# Create 2nd image
date_tag="test-$(date +%s)"
/kaniko/executor \
  --context "/app" \
  --dockerfile "/app/Dockerfile_release" \
  --skip-tls-verify-registry $REGISTRY \
  --destination "${REGISTRY}/${NAMESPACE}/${date_tag}" \
  --cache-repo "${REGISTRY}/${NAMESPACE}/cache" \
  --cache=true \
  --cleanup \
  --build-arg from="${REGISTRY}/${NAMESPACE}/cache-debug-build" \
  --build-arg base="${REGISTRY}/${NAMESPACE}/alpine:3.11" \
  -v $log_level

# Create build image
echo $(date) > /app/date.txt
/kaniko/executor \
  --context "/app" \
  --dockerfile "/app/Dockerfile_build" \
  --skip-tls-verify-registry $REGISTRY \
  --destination "${REGISTRY}/${NAMESPACE}/cache-debug-build" \
  --cache-repo "${REGISTRY}/${NAMESPACE}/cache" \
  --cache=true \
  --cleanup \
  -v $log_level

# Create 3rd Image w/o Cache
date_tag="test-$(date +%s)"
/kaniko/executor \
  --context "/app" \
  --dockerfile "/app/Dockerfile_release" \
  --skip-tls-verify-registry $REGISTRY \
  --destination "${REGISTRY}/${NAMESPACE}/${date_tag}" \
  --cache-repo "${REGISTRY}/${NAMESPACE}/cache" \
  --cache=false \
  --cleanup \
  --build-arg from="${REGISTRY}/${NAMESPACE}/cache-debug-build" \
  --build-arg base="${REGISTRY}/${NAMESPACE}/alpine:3.11" \
  -v $log_level
