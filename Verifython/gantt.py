import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Dates and times for study schedule
start_date = pd.to_datetime('2024-10-31')  # Starting date (Thursday)
study_duration = pd.Timedelta('2 hours')  # Duration of each session

# Themes for study plan (including all requested themes)
themes = [
    # Priority themes
    "Le Don des Langues (Parler en Langues)", "La Place de la Femme dans l'Église", "La Justification par la Foi (Sola Fide)",
    "Les Dons Spirituels et Leur Usage", "Le Royaume de Dieu", "La Résurrection des Morts et la Vie Éternelle",

    # Théologie Propre
    "Théologie Propre: Trinité - Dieu le Père", "Théologie Propre: Trinité - Dieu le Fils (Jésus-Christ)",
    "Théologie Propre: Trinité - Dieu le Saint-Esprit", "Théologie Propre: Attributs de Dieu - Omnipotence",
    "Théologie Propre: Attributs de Dieu - Omniprésence", "Théologie Propre: Attributs de Dieu - Omniscience",
    "Théologie Propre: Attributs de Dieu - Amour et Justice", "Théologie Propre: Création - Origine de l'Univers",
    "Théologie Propre: Création - Origine de l'Humanité", "Théologie Propre: Création - Providence",

    # Christologie
    "Christologie: Incarnation", "Christologie: Vie et Ministère de Jésus", "Christologie: Mort et Résurrection",
    "Christologie: Ascension", "Christologie: Parousie (Retour de Jésus)",

    # Pneumatologie
    "Pneumatologie: Rôle du Saint-Esprit", "Pneumatologie: Don du Saint-Esprit", "Pneumatologie: Fruits du Saint-Esprit",
    "Pneumatologie: Dons spirituels",

    # Anthropologie
    "Anthropologie: Création de l'Humanité", "Anthropologie: Chute et Péché Originel", "Anthropologie: Nature Humaine",
    "Anthropologie: Destinée Humaine",

    # Sotériologie
    "Sotériologie: Justification", "Sotériologie: Sanctification", "Sotériologie: Rédemption", "Sotériologie: Grâce",
    "Sotériologie: Foi et Œuvres",

    # Ecclésiologie
    "Ecclésiologie: Nature de l'Église", "Ecclésiologie: Mission de l'Église", "Ecclésiologie: Baptême",
    "Ecclésiologie: Eucharistie", "Ecclésiologie: Confirmation", "Ecclésiologie: Mariage", "Ecclésiologie: Ordination",
    "Ecclésiologie: Pénitence", "Ecclésiologie: Onction des Malades", "Ecclésiologie: Ministères et Vocations",

    # Eschatologie
    "Eschatologie: Mort", "Eschatologie: Jugement", "Eschatologie: Ciel", "Eschatologie: Enfer", "Eschatologie: Résurrection des Morts",
    "Eschatologie: Vie Éternelle",

    # Éthique Chrétienne
    "Éthique Chrétienne: Morale Personnelle", "Éthique Chrétienne: Morale Sociale", "Éthique Chrétienne: Justice Sociale",
    "Éthique Chrétienne: Éthique Sexuelle",

    # Révélation
    "Révélation: Révélation Générale", "Révélation: Révélation Spéciale", "Révélation: Bible (Ancien et Nouveau Testament)",
    "Révélation: Tradition", "Révélation: Inspiration et Autorité des Écritures",

    # Liturgie et Culte
    "Liturgie et Culte: Adoration", "Liturgie et Culte: Prière", "Liturgie et Culte: Louange",
    "Liturgie et Culte: Prédication", "Liturgie et Culte: Sacrements"
]

# Estimate sessions per theme (some may need 1 session, some may need 2)
sessions_per_theme = {
    "Le Don des Langues (Parler en Langues)": 2,
    "La Place de la Femme dans l'Église": 2,
    "La Justification par la Foi (Sola Fide)": 2,
    "Les Dons Spirituels et Leur Usage": 2,
    "Le Royaume de Dieu": 2,
    "La Résurrection des Morts et la Vie Éternelle": 2,
    "Théologie Propre: Trinité - Dieu le Père": 2,
    "Théologie Propre: Trinité - Dieu le Fils (Jésus-Christ)": 2,
    "Théologie Propre: Trinité - Dieu le Saint-Esprit": 2,
    "Théologie Propre: Attributs de Dieu - Omnipotence": 2,
    "Théologie Propre: Attributs de Dieu - Omniprésence": 2,
    "Théologie Propre: Attributs de Dieu - Omniscience": 1,
    "Théologie Propre: Attributs de Dieu - Amour et Justice": 2,
    "Théologie Propre: Création - Origine de l'Univers": 2,
    "Théologie Propre: Création - Origine de l'Humanité": 1,
    "Théologie Propre: Création - Providence": 1,
    # Rest default to 2 sessions
}

# Default for the themes not specified
for theme in themes:
    if theme not in sessions_per_theme:
        sessions_per_theme[theme] = 2

# Calculate study sessions based on themes and start date
study_schedule = []
for theme in themes:
    for session in range(sessions_per_theme[theme]):
        study_date = start_date + pd.DateOffset(weeks=len(study_schedule))
        study_schedule.append({'Date': study_date, 'Theme': theme})

# Convert study_schedule to DataFrame
schedule_df = pd.DataFrame(study_schedule)

# Create Gantt chart
fig, ax = plt.subplots(figsize=(12, 10))
ax.set_title('Gantt Chart of Study Plan', fontsize=16)
ax.set_xlabel('Date', fontsize=12)
ax.set_ylabel('Themes', fontsize=12)

# Assign a unique color to each theme
theme_colors = plt.cm.viridis(np.linspace(0, 1, len(themes)))

# Plot the Gantt chart for each theme
for idx, theme in enumerate(themes):
    theme_data = schedule_df[schedule_df['Theme'] == theme]
    ax.barh(theme, theme_data['Date'].apply(lambda x: 1), left=theme_data['Date'], color=theme_colors[idx], height=0.5)

    # Ajouter des étiquettes de date
    for date in theme_data['Date']:
        ax.text(date, idx, str(date.date()), va='center', fontsize=8)

# Ajouter une légende
legend_elements = [plt.Line2D([0], [0], color=theme_colors[idx], lw=4, label=theme) for idx, theme in enumerate(themes)]
ax.legend(handles=legend_elements, loc='upper left', bbox_to_anchor=(1.05, 1))

# Customize x-axis
plt.xticks(rotation=45)
plt.tight_layout()

plt.show()
