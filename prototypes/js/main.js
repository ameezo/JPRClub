document.addEventListener('DOMContentLoaded', () => {
    // Language Toggle
    const langToggleBtn = document.getElementById('lang-toggle');
    if (langToggleBtn) {
        langToggleBtn.addEventListener('click', () => {
            const htmlTag = document.documentElement;
            if (htmlTag.getAttribute('dir') === 'rtl') {
                htmlTag.setAttribute('dir', 'ltr');
                htmlTag.setAttribute('lang', 'en');
                langToggleBtn.textContent = 'AR'; // Show option to switch to AR
            } else {
                htmlTag.setAttribute('dir', 'rtl');
                htmlTag.setAttribute('lang', 'ar');
                langToggleBtn.textContent = 'EN'; // Show option to switch to EN
            }
        });
    }
});
