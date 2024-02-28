package Helper;

import java.io.*;

public class VideoStream {
    FileInputStream fis;
    int frame_nb;

    public VideoStream(String filename) throws Exception{
        fis = new FileInputStream(filename);
        frame_nb = 0;
    }

    public int getnextframe(byte[] frame) throws Exception
    {
        int length;
        String length_string;
        byte[] frame_length = new byte[5];

        fis.read(frame_length,0,5);

        length_string = new String(frame_length);
        length = Integer.parseInt(length_string);

        return(fis.read(frame,0,length));
    }
}