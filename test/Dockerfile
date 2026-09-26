# Throwaway environment for exercising install.clj against a real $HOME.
# Runs as root so /usr/local/bin targets are writable.
FROM babashka/babashka:latest

WORKDIR /dotfiles
COPY . /dotfiles
RUN chmod +x install.clj test/e2e-tests.clj

ENTRYPOINT ["bb", "/dotfiles/test/e2e-tests.clj"]
