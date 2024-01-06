// Publisher
import List "mo:base/List";

// Define an actor called Publisher
actor Publisher {

  // Create a new type called 'Counter' that stores a key-value pair of 'topic: value'.
  type Counter = {
    topic : Text;
    value : Nat;
  };

  // Create a new type called 'Subscriber' that stores a key-value pair of 'topic: callback'. Callback refers to the inter-canister call that sends the 'Counter' key-value pair to canisters in the 'subscribers' variable.
  type Subscriber = {
    topic : Text;
    callback : shared Counter -> ();
  };

  // Define a stable variable that stores the list of canisters 'subscribed' to a topic on the 'Publisher' canister.
  stable var subscribers = List.nil<Subscriber>();

  // Define a function that enables canisters to subscribe to a topic.
  public func subscribe(subscriber : Subscriber) {
    subscribers := List.push(subscriber, subscribers);
  };

  // Define the function to create new topics submitted by the 'Subscriber' canister within the 'Counter' key-value pair.
  public func publish(counter : Counter) {
    for (subscriber in List.toArray(subscribers).vals()) {
      if (subscriber.topic == counter.topic) {
        subscriber.callback(counter);
      };
    };
  };
}
