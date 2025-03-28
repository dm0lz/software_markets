// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import "./channels";
import "./landing";
import { createIcons, icons } from "lucide";

// Caution, this will import all the icons and bundle them.
const onTurboLoad = () => {
  createIcons({ icons });
};

document.addEventListener("turbo:load", onTurboLoad);
