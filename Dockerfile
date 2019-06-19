FROM jekyll/builder

ENV HOME=/home/jekyll
WORKDIR ${HOME}

RUN cat /etc/passwd | sed s#jekyll:x.*#jekyll:x:\${USER_ID}:\${GROUP_ID}::\${HOME}:/bin/sh#g > ${HOME}/passwd.template \
    && cat /etc/group | sed s#jekyll:x:1000:#jekyll:x:1000:1000,\${USER_ID}:#g > ${HOME}/group.template \
    # Change permissions to let any arbitrary user
    && for f in "${HOME}" "/etc/passwd" "/etc/group" "${JEKYLL_DATA_DIR}" "${JEKYLL_VAR_DIR}"; do \
        echo "Changing permissions on ${f}" && chgrp -R 0 ${f} && \
        chmod -R g+rwX ${f}; \
    done

ADD entrypoint.sh /usr/jekyll/bin/entrypoint
ENTRYPOINT ["/usr/jekyll/bin/entrypoint"]

