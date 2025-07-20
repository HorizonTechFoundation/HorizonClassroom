# FOR CREATE

cd Backend
python3 -m venv venv

source venv/bin/activate   # For Linux/macOS

[ OR ]

venv\Scripts\activate      # For Windows


# FOR RUN

cd Backend
venv\Scripts\activate

# .env SETUP

cd Backend
cd horizon_classroom_backend
nano .env

DEBUG=True
SECRET_KEY=your-super-secret-key
DATABASE_NAME=db.sqlite3

