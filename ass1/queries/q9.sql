# Add constraints to the Sakila database which require that no last name appear as both a
# customer and a movie actor
USE sakila;
CREATE TRIGGER customerTrigger
BEFORE INSERT
    ON customer
FOR EACH ROW
BEGIN
    if not exists(select 1 from customer as c, actor as a where c.last_name = NEW.last_name or a.last_name = NEW.last_name)
    THEN
        INSERT INTO customer(customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update)
        VALUES (NEW.customer_id, NEW.store_id, NEW.first_name, NEW.last_name, NEW.email, NEW.address_id, NEW.active, NEW.create_date, NEW.last_update);
    END IF;
END;

CREATE TRIGGER actorTrigger
BEFORE INSERT
    ON actor
FOR EACH ROW
BEGIN
    if not exists(select 1 from customer as c, actor as a where c.last_name = NEW.last_name or a.last_name = NEW.last_name)
    THEN
        INSERT INTO actor(actor_id, first_name, last_name, last_update)
        VALUES (NEW.actor_id, NEW.first_name, NEW.last_name, NEW.last_update);
    END IF;
END;
