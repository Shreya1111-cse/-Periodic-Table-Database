Periodic Table Database ⚛️
This project is part of freeCodeCamp's Relational Database course. It involves fixing a PostgreSQL periodic table database and creating a bash script to query element information.

✨ Features
Database Fixes: Renamed columns, added constraints, set up foreign keys, and added element types.

Data Updates: Corrected existing data and added new elements (Fluorine and Neon).

element.sh Script: A command-line tool to quickly get element details by atomic number, symbol, or name.

Error Handling: Includes checks for missing arguments and elements not found.

🚀 Quick Start (Script)
Navigate: cd project/periodic_table

Permissions: chmod +x element.sh

Run:

./element.sh 1 (Hydrogen's info)

./element.sh F (Fluorine's info)

./element.sh NonexistentElement (I could not find that element...)

./element.sh (Please provide an element...)

🛠️ Database Setup
The periodic_table.sql file contains all the SQL commands to configure the database.

Connect to PostgreSQL: psql -U postgres

Execute SQL dump: \i /path/to/your/periodic_table.sql (e.g., \i project/periodic_table/periodic_table.sql)

📂 Structure
project/
└── periodic_table/
    ├── element.sh            # The bash script
    └── periodic_table.sql    # Database dump

This project was completed for freeCodeCamp. Happy coding! 🧪
