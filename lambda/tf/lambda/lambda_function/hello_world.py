import os

def main_handler(event, context):
    
    test_var = os.environ['test_var']
    return {"message": test_var, "Status": 200}