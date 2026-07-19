# Abstractions

- I need to make some abstractions
  - colorscheme loader: what it does is collect all the colorschemes across the install, extend / strip them and provide a global api for different elements to set colorschemes.
  - lazy + lze wrapper: As, I want to use the same config in my nix based and non-nix based setup, it would be hard to carry 2 different configurations for different loaders, so this abstraction provides a unified config then translates it to whatever package manager is being used. Further it provides pre-load and post-load scripts so I can set plugin specific keymaps.
  - A dbus like global object for sharing different settings globally.
  - Load chain: several steps load chain and these events are met one after another like a DAG, explicit load order for every MODULE not just plugin, making sure that everything works clearly.
  - Module based loading: Rather than files directly executing code we have modules declaration first then execution phase dependent on the **Load Chain**, making sure everything is predefined and errors based of things not being loaded doesn't happen
