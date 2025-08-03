    TIMESTAMP=$(date +%Y%m%d.%H%M)
    if [[ "$CUSTOM_VERSION" == *SNAPSHOT ]]; then
      JAR_NAME="${PROJECT_NAME}-$(echo $CUSTOM_VERSION | sed "s/SNAPSHOT/$TIMESTAMP/")"
    else
      JAR_NAME="${PROJECT_NAME}-${CUSTOM_VERSION}"
    fi
