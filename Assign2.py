from flask import Flask

app = Flask(__name__)

# Define a route to display company name, developer's name, and student ID
@app.route('/')
def index():
    company_name = "Wild Rydes"
    developer_name = "Mary Airhunde"
    student_id = "100953904"
    return f"Company Name: {company_name}<br>Developer: {developer_name}<br>Student ID: {student_id}"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8080)
