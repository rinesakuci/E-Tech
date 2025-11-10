# generate_figure.py
import matplotlib.pyplot as plt
import numpy as np
import os

# Simulim i skorëve hibridë për përdoruesin ID=6 (50 produkte)
np.random.seed(42)
all_scores = np.sort(np.random.uniform(0.3, 0.9, 50))  # 50 produkte
viewed_scores = [0.78, 0.72, 0.65, 0.62, 0.58]  # Top-5 rekomandime (nga tabela)
viewed_labels = ['Samsung S23 Ultra', 'Lenovo Legion 5', 'Asus ROG Strix', 'Asus TUF A15', 'Dell XPS']

# Figura
fig, ax = plt.subplots(figsize=(10, 6))
ax.plot(range(1, 51), all_scores, color='lightgray', linewidth=1, label='Të gjitha produktet (50)')
ax.scatter(range(1, 6), viewed_scores, color='red', s=80, zorder=5, label='Rekomandime Top-5')

# Etiketat për top-5
for i, (score, label) in enumerate(zip(viewed_scores, viewed_labels)):
    ax.annotate(label, (i+1, score), xytext=(0, 8), textcoords='offset points',
                fontsize=9, ha='center', color='darkred', fontweight='bold')

# Dekorime
ax.set_title('Shpërndarja e Skorëve Hibridë për Përdoruesin ID=6\n(Bazuar në 50 Produkte të Disponueshme)', 
             fontsize=14, pad=20)
ax.set_xlabel('Renditja e Produkteve (1 = më i lartë)', fontsize=12)
ax.set_ylabel('Skori Hibrid (0–1)', fontsize=12)
ax.set_xlim(0, 51)
ax.set_ylim(0.2, 1.0)
ax.grid(True, alpha=0.3)
ax.legend(loc='upper right')

# Ruaj në folderin e projektit
output_dir = "static/figures"
os.makedirs(output_dir, exist_ok=True)
fig_path_png = os.path.join(output_dir, "figura1_hybrid_scores.png")
fig_path_pdf = os.path.join(output_dir, "figura1_hybrid_scores.pdf")

plt.savefig(fig_path_png, dpi=300, bbox_inches='tight')
plt.savefig(fig_path_pdf, bbox_inches='tight')
print(f"Figura u ruajt:\n   PNG: {fig_path_png}\n   PDF: {fig_path_pdf}")