const menuToggle = document.getElementById("menuToggle");
const siteNav = document.getElementById("siteNav");
const countdownEl = document.getElementById("countdown");

if (menuToggle && siteNav) {
  menuToggle.addEventListener("click", () => {
    siteNav.classList.toggle("open");
  });

  siteNav.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", () => {
      siteNav.classList.remove("open");
    });
  });
}

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("in-view");
      }
    });
  },
  { threshold: 0.15 }
);

document.querySelectorAll(".reveal").forEach((section) => {
  observer.observe(section);
});

if (countdownEl) {
  let totalSeconds = 48 * 60 * 60 - 1;

  const formatTime = (seconds) => {
    const hrs = String(Math.floor(seconds / 3600)).padStart(2, "0");
    const mins = String(Math.floor((seconds % 3600) / 60)).padStart(2, "0");
    const secs = String(seconds % 60).padStart(2, "0");
    return `${hrs}:${mins}:${secs}`;
  };

  countdownEl.textContent = formatTime(totalSeconds);

  setInterval(() => {
    totalSeconds = totalSeconds > 0 ? totalSeconds - 1 : 48 * 60 * 60 - 1;
    countdownEl.textContent = formatTime(totalSeconds);
  }, 1000);
}
