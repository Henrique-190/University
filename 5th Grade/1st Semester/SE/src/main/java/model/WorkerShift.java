package model;

import java.sql.*;


public class WorkerShift {
    private final String id_worker;
    private final Timestamp begin;
    private final Timestamp end;

    public WorkerShift(String id_worker, Timestamp begin, Timestamp end) {
        this.id_worker = id_worker;
        this.begin = begin;
        this.end = end;
    }

    public String getIdWorker() {
        return this.id_worker;
    }

    public Timestamp getBegin() {
        return this.begin;
    }

    public Timestamp getEnd() {
        return this.end;
    }
}
