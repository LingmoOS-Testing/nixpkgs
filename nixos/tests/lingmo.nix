import ./make-test-python.nix ({pkgs, ...}: {
  name = "lingmo";
  meta = with pkgs.lib.maintainers; [arkimium_76];

  machine = {...}: {
    imports = [./common/user-account.nix];
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.defaultSession = "lingmo-session";
    services.xserver.desktopManager.lingmo.enable = true;
    services.xserver.displayManager.autoLogin = {
      enable = true;
      user = "alice";
    };
    virtualisation.memorySize = 1024;
  };

  enableOCR = true;

  testScript = {nodes, ...}: let
    user = nodes.machine.config.users.users.alice;
    userCommand = "su - ${user.name} -c 'DISPLAY=:0.0 XDG_RUNTIME_DIR=/run/user/${toString user.uid}'";
  in ''
    def assert_process_running(processes):
        for process in processes:
            machine.wait_until_succeeds("pgrep -f " + process)

    def assert_can_run_app(executable, windows, texts):
        machine.execute("${userCommand} ${executable} &")

        for window in windows:
            machine.wait_for_window(window)

        for text in texts:
            machine.wait_for_text(text)

    with subtest("Wait for login"):
        start_all()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")

    with subtest("Lingmo components are running"):
        assert_process_running([
            "chotkeys",
            "lingmo-dock",
            "lingmo-filemanager",
            "lingmo-launcher",
            "lingmo-polkit-agent",
            "lingmo-powerman",
            "lingmo-session",
            "lingmo-settings-daemon",
            "lingmo-statusbar",
            "lingmo-xembedsniproxy",
            "kwin_x11"
        ])

    with subtest("Launcher can find apps"):
        assert_can_run_app("lingmo-launcher", [], ["Calculator", "File Manager", "Settings", "Terminal"])

    with subtest("Can run Settings"):
        assert_can_run_app("lingmo-settings", ["lingmo-settings"], ["Settings"])

    with subtest("Can run basic gui apps"):
        assert_can_run_app("lingmo-calculator", ["lingmo-calculator"], ["Calculator"])
        assert_can_run_app("lingmo-filemanager", ["lingmo-filemanager"], ["File Manager"])
        assert_can_run_app("lingmo-terminal", ["lingmo-terminal"], ["Terminal"])
  '';
})
