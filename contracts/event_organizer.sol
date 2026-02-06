// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EventTicket {
    struct Event {
        address organizer;
        string name;
        uint256 date;          // timestamp
        uint256 price;         // price per ticket in wei
        uint256 ticketCount;   // total tickets created
        uint256 ticketRemain;  // tickets still available
    }

    // eventId → Event
    mapping(uint256 => Event) public events;

    // buyer → eventId → ticket count owned
    mapping(address => mapping(uint256 => uint256)) public tickets;

    uint256 public nextId;

    // === EVENTS (for frontend/indexing) ===
    event EventCreated(
        uint256 indexed eventId,
        address indexed organizer,
        string name,
        uint256 date,
        uint256 price,
        uint256 ticketCount
    );

    event TicketPurchased(
        uint256 indexed eventId,
        address indexed buyer,
        uint256 quantity
    );

    event TicketTransferred(
        uint256 indexed eventId,
        address indexed from,
        address indexed to,
        uint256 quantity
    );

    function createEvent(
        string memory name,
        uint256 date,
        uint256 price,
        uint256 ticketCount
    ) external {
        require(date > block.timestamp, "Event must be in the future");
        require(ticketCount > 0, "Must create at least 1 ticket");
        // price can be 0 (free event)

        uint256 eventId = nextId;

        events[eventId] = Event({
            organizer: msg.sender,
            name: name,
            date: date,
            price: price,
            ticketCount: ticketCount,
            ticketRemain: ticketCount
        });

        ++nextId;

        emit EventCreated(eventId, msg.sender, name, date, price, ticketCount);
    }

    function buyTicket(uint256 id, uint256 quantity) external payable {
        Event storage e = events[id];

        require(e.organizer != address(0), "Event does not exist");
        require(e.date > block.timestamp, "Event has already passed");
        require(quantity > 0, "Must buy at least 1 ticket");
        require(e.ticketRemain >= quantity, "Not enough tickets remaining");

        uint256 totalCost = e.price * quantity;
        require(msg.value == totalCost, "Incorrect payment amount");

        e.ticketRemain -= quantity;
        tickets[msg.sender][id] += quantity;

        // Send money to organizer immediately (common pattern)
        (bool sent, ) = payable(e.organizer).call{value: totalCost}("");
        require(sent, "Payment failed");

        emit TicketPurchased(id, msg.sender, quantity);
    }

    function transferTicket(uint256 id, uint256 quantity, address to) external {
        require(to != address(0), "Invalid recipient");
        require(quantity > 0, "Must transfer at least 1 ticket");

        Event storage e = events[id];
        require(e.organizer != address(0), "Event does not exist");
        require(e.date > block.timestamp, "Cannot transfer after event");

        require(tickets[msg.sender][id] >= quantity, "Not enough tickets to transfer");

        tickets[msg.sender][id] -= quantity;
        tickets[to][id] += quantity;

        emit TicketTransferred(id, msg.sender, to, quantity);
    }

    // Helper: check how many tickets caller owns for an event
    function myTickets(uint256 eventId) external view returns (uint256) {
        return tickets[msg.sender][eventId];
    }
}
