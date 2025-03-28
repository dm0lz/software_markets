import Prism from "prismjs";
import "prismjs/components/prism-bash";
import "prismjs/components/prism-json";
import "prismjs/components/prism-ruby";
import "prismjs/components/prism-javascript";
import "prismjs/components/prism-python";

function toggleAccordion(id) {
  const content = document.getElementById(id);
  const button = content.previousElementSibling;
  const icon = button.querySelector(".lucide-chevron-up, .lucide-chevron-down");
  content.classList.toggle("hidden");
  icon.classList.toggle("rotate-180");
  if (!content.classList.contains("hidden")) {
    Prism.highlightAll();
  }
}

document.querySelectorAll(".toggle-accordion").forEach((button) => {
  button.addEventListener("click", (event) => {
    toggleAccordion(event.currentTarget.dataset.endpoint);
  });
});

function switchTab(endpoint, tab) {
  document
    .querySelector("#" + endpoint)
    .querySelectorAll(".code-block")
    .forEach((block) => {
      block.classList.add("hidden");
    });
  for (let element of document
    .querySelector("#" + endpoint)
    .querySelectorAll("." + tab)) {
    element.classList.remove("hidden");
  }
  document
    .querySelector("#" + endpoint)
    .querySelectorAll(".tab-button")
    .forEach((tab) => {
      tab.classList.remove("border-indigo-500", "text-indigo-600");
      tab.classList.add("border-transparent", "text-gray-600");
    });
  const activeTab = document.querySelector(`#${endpoint} [data-tab="${tab}"]`);
  activeTab.classList.remove("border-transparent", "text-gray-600");
  activeTab.classList.add("border-indigo-500", "text-indigo-600");
  Prism.highlightAll();
}

document.querySelectorAll(".switch-tab").forEach((button) => {
  button.addEventListener("click", (event) => {
    switchTab(
      event.target.parentNode.parentNode.parentNode.parentNode.id,
      event.target.dataset.tab
    );
  });
});

document.addEventListener("turbo:load", () => {
  Prism.highlightAll();
});
