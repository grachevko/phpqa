FROM php:7.1-cli

MAINTAINER Jakub Zalas <jakub@zalas.pl>

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV BUILD_DEPS="autoconf file g++ gcc libc-dev make pkg-config re2c unzip"
ENV LIB_DEPS="zlib1g-dev"
ENV TOOL_DEPS="git graphviz"
ENV PATH="$PATH:/root/.composer/vendor/bin:/root/QualityAnalyzer/bin:/root/DesignPatternDetector/bin"

RUN apt-get update && apt-get install -y --no-install-recommends $TOOL_DEPS $BUILD_DEPS $LIB_DEPS && rm -rf /var/lib/apt/lists/* \
 && git clone https://github.com/nikic/php-ast.git && cd php-ast && phpize && ./configure && make && make install && cd .. && rm -rf php-ast && docker-php-ext-enable ast \
 && docker-php-ext-install zip \
 && echo "date.timezone=Europe/London" >> $PHP_INI_DIR/php.ini \
 && echo "memory_limit=-1" >> $PHP_INI_DIR/php.ini \
 && echo "phar.readonly=0" >> $PHP_INI_DIR/php.ini \
 && curl -Ls https://getcomposer.org/composer.phar > /usr/local/bin/composer && chmod +x /usr/local/bin/composer \
 && curl -Ls https://box-project.github.io/box2/installer.php | php && mv box.phar /usr/local/bin/box && chmod +x /usr/local/bin/box \
 && curl -Ls http://cs.sensiolabs.org/download/php-cs-fixer-v2.phar > /usr/local/bin/php-cs-fixer && chmod +x /usr/local/bin/php-cs-fixer \
 && curl -Ls https://github.com/dunglas/phpdoc-to-typehint/releases/download/v0.1.0/phpdoc-to-typehint.phar > /usr/local/bin/phpdoc-to-typehint && chmod +x /usr/local/bin/phpdoc-to-typehint \
 && curl -Ls https://github.com/phpmetrics/PhpMetrics/releases/download/v2.2.0/phpmetrics.phar > /usr/local/bin/phpmetrics && chmod +x /usr/local/bin/phpmetrics \
 && curl -Ls https://github.com/phpstan/phpstan/releases/download/0.8.3/phpstan.phar > /usr/local/bin/phpstan && chmod +x /usr/local/bin/phpstan \
 && curl -Ls https://github.com/etsy/phan/releases/download/0.9.4/phan.phar > /usr/local/bin/phan && chmod +x /usr/local/bin/phan \
 && curl -Ls https://phar.dephpend.com/dephpend.phar > /usr/local/bin/dephpend && chmod +x /usr/local/bin/dephpend \
 && curl -Ls http://phpdoc.org/phpDocumentor.phar > /usr/local/bin/phpDocumentor && chmod +x /usr/local/bin/phpDocumentor \
 && curl -Ls https://phar.phpunit.de/phpcpd.phar > /usr/local/bin/phpcpd && chmod +x /usr/local/bin/phpcpd \
 && curl -Ls https://phar.phpunit.de/phploc.phar > /usr/local/bin/phploc && chmod +x /usr/local/bin/phploc \
 && curl -Ls http://static.phpmd.org/php/latest/phpmd.phar > /usr/local/bin/phpmd && chmod +x /usr/local/bin/phpmd \
 && curl -Ls http://static.pdepend.org/php/latest/pdepend.phar > /usr/local/bin/pdepend && chmod +x /usr/local/bin/pdepend \
 && curl -Ls https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar > /usr/local/bin/phpcs && chmod +x /usr/local/bin/phpcs \
 && curl -Ls https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar > /usr/local/bin/phpcbf && chmod +x /usr/local/bin/phpcbf  \
 && curl -Ls https://github.com/bytepark/php-phar-qatools/raw/master/phpcb.phar > /usr/local/bin/phpcb && chmod +x /usr/local/bin/phpcb \
 && curl -Ls https://github.com/sensiolabs-de/deprecation-detector/releases/download/0.1.0-alpha4/deprecation-detector.phar > /usr/local/bin/deprecation-detector && chmod +x /usr/local/bin/deprecation-detector \
 && curl -Ls http://get.sensiolabs.de/deptrac.phar > /usr/local/bin/deptrac && chmod +x /usr/local/bin/deptrac \
 && curl -sL https://raw.github.com/mamuz/PhpDependencyAnalysis/master/download/phpda.pubkey > /usr/local/bin/phpda.pubkey && curl -sL https://raw.github.com/mamuz/PhpDependencyAnalysis/master/download/phpda > /usr/local/bin/phpda && chmod +x /usr/local/bin/phpda \
 && curl -Ls http://psvc.coreteks.org/php-semver-checker.phar > /usr/local/bin/php-semver-checker && chmod +x /usr/local/bin/php-semver-checker \
 && composer global require --no-suggest --prefer-dist --update-no-dev -n akeneo/php-coupling-detector edsonmedina/php_testability:dev-master vimeo/psalm povils/phpmnd wapmorgan/php-code-fixer wapmorgan/php-code-analyzer rskuipers/php-assumptions:dev-master bmitch/churn-php \
 && cd $HOME && git clone https://github.com/Qafoo/QualityAnalyzer.git && cd $HOME/QualityAnalyzer && composer install --no-dev --no-suggest --prefer-dist -n \
 && cd $HOME && git clone https://github.com/Halleck45/DesignPatternDetector.git && cd $HOME/DesignPatternDetector && composer install --no-dev --no-suggest --prefer-dist -n \
 && cd $HOME && git clone https://github.com/JakubOnderka/PHP-Parallel-Lint.git && cd $HOME/PHP-Parallel-Lint && composer install --no-dev --no-suggest --prefer-dist -n && box build && mv parallel-lint.phar /usr/local/bin/parallel-lint && chmod +x /usr/local/bin/parallel-lint && cd && rm -rf $HOME/PHP-Parallel-Lint \
 && cd $HOME && git clone https://github.com/mmoreram/php-formatter.git && cd $HOME/php-formatter && composer install --no-dev --no-suggest --prefer-dist -n && box build && mv build/php-formatter.phar /usr/local/bin/php-formatter && chmod +x /usr/local/bin/php-formatter && cd && rm -rf $HOME/php-formatter \
 && apt-get purge -y --auto-remove $BUILD_DEPS

ADD list-tools.sh /usr/local/bin/list-tools.sh
CMD /usr/local/bin/list-tools.sh
