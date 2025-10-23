document.addEventListener('DOMContentLoaded', function() {
    // Validim per login form
    const loginForm = document.getElementById('login-form');
    if (loginForm) {
        const inputs = loginForm.querySelectorAll('input');
        inputs.forEach(input => {
            input.addEventListener('input', function() {
                if (this.value.trim() === '') {
                    this.classList.remove('is-valid');
                    this.classList.add('is-invalid');
                } else {
                    this.classList.remove('is-invalid');
                    this.classList.add('is-valid');
                }
            });
        });
    }

    // AJAX per search dinamik
    const searchInput = document.getElementById('search-input');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const query = this.value;
            if (query.length >= 3) {
                fetch(`/search?q=${encodeURIComponent(query)}`)
                    .then(response => response.text())
                    .then(html => {
                        const parser = new DOMParser();
                        const doc = parser.parseFromString(html, 'text/html');
                        const newProducts = doc.querySelector('.row').innerHTML;
                        document.querySelector('.row').innerHTML = newProducts;
                    })
                    .catch(error => console.error('Gabim:', error));
            }
        });
    }

    // Efekte hover qe jane perdorur per cards
    const cards = document.querySelectorAll('.card');
    cards.forEach(card => {
        card.addEventListener('mouseover', () => {
            card.style.transform = 'scale(1.05)';
            card.style.transition = 'transform 0.3s';
        });
        card.addEventListener('mouseout', () => {
            card.style.transform = 'scale(1)';
        });
    });

    // Drag and Drop per imazh në admin
    const dropzone = document.getElementById('dropzone');
    const imageInput = document.getElementById('image');
    if (dropzone && imageInput) {
        dropzone.addEventListener('dragover', (e) => {
            e.preventDefault();
            dropzone.classList.add('active');
        });
        dropzone.addEventListener('dragleave', () => {
            dropzone.classList.remove('active');
        });
        dropzone.addEventListener('drop', (e) => {
            e.preventDefault();
            dropzone.classList.remove('active');
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                imageInput.files = files;
                dropzone.textContent = `File selected: ${files[0].name}`;
            }
        });
        dropzone.addEventListener('click', () => {
            imageInput.click();
        });
        imageInput.addEventListener('change', () => {
            if (imageInput.files.length > 0) {
                dropzone.textContent = `File selected: ${imageInput.files[0].name}`;
            }
        });
    }

    // AJAX per rekomandime si toast
    if (document.body.classList.contains('home-page')) {
        fetch('/recommendations')
            .then(response => response.text())
            .then(html => {
                const toastContainer = document.createElement('div');
                toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
                toastContainer.innerHTML = html;
                document.body.appendChild(toastContainer);
                const toasts = toastContainer.querySelectorAll('.toast');
                toasts.forEach(toast => new bootstrap.Toast(toast).show());
            })
            .catch(error => console.error('Gabim në rekomandime:', error));
    }
});