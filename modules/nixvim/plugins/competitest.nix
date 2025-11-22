{lib, ...}: {
  plugins.competitest = {
    enable = true;
    settings = {
      compile_command.cpp = {
        args = ["-Wall" "-std=c++20" "$(FNAME)" "-o" "$(FNOEXT)"];
        exec = "clang++";
      };
      template_file = lib.nixvim.mkRaw ''
        {
          cpp = "./template.cpp"
        }
      '';
    };
  };
}
