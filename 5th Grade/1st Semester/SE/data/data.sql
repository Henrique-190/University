-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema leitrack
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema leitrack
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `leitrack` DEFAULT CHARACTER SET utf8 ;
USE `leitrack` ;

-- -----------------------------------------------------
-- Table `leitrack`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leitrack`.`User` (
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `name` VARCHAR(80) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `address` VARCHAR(80) NOT NULL,
  `phone_number` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `phone_number_UNIQUE` (`phone_number` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `leitrack`.`Worker`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leitrack`.`Worker` (
  `id_worker` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_worker`),
  CONSTRAINT `idUserWorkerFK`
    FOREIGN KEY (`id_worker`)
    REFERENCES `leitrack`.`User` (`username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `leitrack`.`OrderTrack`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leitrack`.`OrderTrack` (
  `id_order` VARCHAR(45) NOT NULL,
  `status` INT NOT NULL,
  `id_client` VARCHAR(45) NULL,
  `phone_number` VARCHAR(45) NOT NULL,
  `id_register` VARCHAR(45) NOT NULL,
  `id_handler` VARCHAR(45) NULL,
  `address` VARCHAR(80) NOT NULL,
  `date_registered` TIMESTAMP NOT NULL,
  `date_expected` TIMESTAMP NOT NULL,
  `date_handled` TIMESTAMP NULL,
  `date_delivered` TIMESTAMP NULL,
  `latitude_now` DOUBLE NOT NULL,
  `longitude_now` DOUBLE NOT NULL,
  PRIMARY KEY (`id_order`),
  INDEX `idWorkerOrder1FK_idx` (`id_register` ASC) VISIBLE,
  INDEX `idWorkerOrder1FK_idx1` (`id_handler` ASC) VISIBLE,
  INDEX `idClientOrder2FK_idx` (`id_client` ASC) VISIBLE,
  CONSTRAINT `idWorkerOrder1FK`
    FOREIGN KEY (`id_register`)
    REFERENCES `leitrack`.`Worker` (`id_worker`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idWorkerOrder2FK`
    FOREIGN KEY (`id_handler`)
    REFERENCES `leitrack`.`Worker` (`id_worker`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idClientOrder2FK`
    FOREIGN KEY (`id_client`)
    REFERENCES `leitrack`.`User` (`username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `leitrack`.`Admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leitrack`.`Admin` (
  `id_admin` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_admin`),
  CONSTRAINT `idUserFKAdmin`
    FOREIGN KEY (`id_admin`)
    REFERENCES `leitrack`.`User` (`username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `leitrack`.`Client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leitrack`.`Client` (
  `id_client` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_client`),
  UNIQUE INDEX `id_client_UNIQUE` (`id_client` ASC) VISIBLE,
  CONSTRAINT `idUserFK`
    FOREIGN KEY (`id_client`)
    REFERENCES `leitrack`.`User` (`username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `leitrack`.`WorkerShifts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leitrack`.`WorkerShifts` (
  `id_worker` VARCHAR(45) NOT NULL,
  `begin` TIMESTAMP NOT NULL,
  `end` TIMESTAMP NULL,
  PRIMARY KEY (`id_worker`, `begin`),
  CONSTRAINT `idWorkerShiftFK`
    FOREIGN KEY (`id_worker`)
    REFERENCES `leitrack`.`Worker` (`id_worker`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `leitrack`.`Notification`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `leitrack`.`Notification` (
  `id_client` VARCHAR(45) NOT NULL,
  `id_order` VARCHAR(45) NOT NULL,
  `date_created` TIMESTAMP NOT NULL,
  `content` VARCHAR(350) NOT NULL,
  PRIMARY KEY (`id_client`, `id_order`, `date_created`, `content`),
  INDEX `IDOrderNotificationFK_idx` (`id_order` ASC) VISIBLE,
  CONSTRAINT `IDClientNotificationFK`
    FOREIGN KEY (`id_client`)
    REFERENCES `leitrack`.`User` (`username`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `IDOrderNotificationFK`
    FOREIGN KEY (`id_order`)
    REFERENCES `leitrack`.`OrderTrack` (`id_order`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
