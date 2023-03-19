import os
from random import random, randint
from mlflow import set_tracking_uri, get_tracking_uri, log_metric, log_param, log_artifacts

if __name__ == "__main__":

    set_tracking_uri("./mlruns")                            # Scenario 1
    #set_tracking_uri("sqlite:///mlruns.db")                # Scenario 3
    #set_tracking_uri("http://localhost:5003")              # Scenario 3

    tracking_uri = get_tracking_uri()
    print("Current tracking uri: {}".format(tracking_uri))

    # Log a parameter (key-value pair)
    log_param("param1", randint(0, 100))

    # Log a metric; metrics can be updated throughout the run
    log_metric("foo", random())
    log_metric("foo", random() + 1)
    log_metric("foo", random() + 2)

    # Log an artifact (output file)
    if not os.path.exists("outputs"):
        os.makedirs("outputs")
    with open("outputs/test.txt", "w") as f:
        f.write("hello world!")
    log_artifacts("outputs")