package Helper;

import Packets.DataPacket;

import java.io.*;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.*;

import org.json.simple.*;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Utils {

    public static HashMap<String, InetAddress> stringNeighborsToMap(String neighbors) throws UnknownHostException {
        // neighbors separados por ';' ver 'lerNeighborsConfigJSON(...)'

        HashMap<String, InetAddress> result = new HashMap<>();
        String[] result1 = neighbors.split(";");

        for (String s : result1) {

            String[] result2 = s.split("=");
            String id = result2[0];
            String ip = result2[1];

            result.put(id, InetAddress.getByName(ip));
        }

        return result;
    }
    public static String lerNeighborsConfigJSON(String path, String id) {
        String result = "";
        JSONParser parser = new JSONParser();

        try (Reader reader = new FileReader(path)) {

            JSONObject jsonObject = (JSONObject) parser.parse(reader);
            //System.out.println(jsonObject);

            // loop array neighbors
            JSONArray msg = (JSONArray) jsonObject.get(id);
            Iterator<String> iterator = msg.iterator();
            while (iterator.hasNext()) {
                //System.out.println(iterator.next());
                 result += iterator.next() + ";";
            }

        } catch (IOException | ParseException e) {
            e.printStackTrace();
        }

        return result;
    }

    public static byte[] lerFicheiroInteiro(String fn) {
        byte[] allBytes = new byte[0];

        try {
            InputStream is = new FileInputStream(fn);
            long fileSize = new File(fn).length();
            allBytes = new byte[(int) fileSize];
            is.read(allBytes);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return allBytes;
    }

    public static List<byte[]> lerFicheiroSegmentado(String fn, int segmentSize) {
        List<byte[]> result = new ArrayList<>();

        try {
            InputStream is = new FileInputStream(fn);
            long fileSize = new File(fn).length();

            double r = (double)fileSize/ (double)segmentSize;
            int fullSegmentCount = (int) Math.floor(r);

            if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_DEBUG_LEVEL)
                System.out.println("Number of Full Segments " + fullSegmentCount + " with size " + segmentSize);

            for (int i = 0; i < fullSegmentCount; i++) {
                byte[] segment = new byte[segmentSize];
                is.read(segment);
                result.add(segment);
            }

            // The remainder segment
            int remainderSize = (int)fileSize % segmentSize;
            if (Configuracao.LOGGER_LEVEL >= Configuracao.LOGGER_DEBUG_LEVEL)
                System.out.println("Remainder segment with size " + remainderSize);

            byte[] remainderSegment = new byte[remainderSize];
            is.read(remainderSegment);
            result.add(remainderSegment);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public static byte[] unwrapDataPackets (DataPacket[] pkts, int numberPackets) {
        ByteArrayOutputStream result = new ByteArrayOutputStream();
        for (int i = 0; i < numberPackets; i++)
            result.writeBytes(pkts[i].getData());

        return result.toByteArray();
    }

    public static void writeToFile (byte[] data, String fn) {
        File outputFile = new File(fn);
        try (FileOutputStream outputStream = new FileOutputStream(outputFile)) {
            outputStream.write(data);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String listFiles (String dir, String delimiter) {
        String result = "";
        File f = new File(dir);

        // Populates the array with names of files and directories
        String[] pathnames = f.list();

        // For each pathname in the pathnames array
        for (String pathname : pathnames) {
            result += pathname;
            result += delimiter;
        }

        return result;
    }

    public static String listFiles (String dir) {
        String result = "";
        File f = new File(dir);

        System.out.println("DEBUG1!!!!!! " + dir);


        // Populates the array with names of files and directories
        String[] pathnames = f.list();

        System.out.println("DEBUG2!!!!!! " + pathnames.toString());

        // For each pathname in the pathnames array
        for (String pathname : pathnames) {
            result += pathname;
            result += Configuracao.FILES_DELIMITER;
        }

        return result;
    }

    public static String diffFiles (String otherFiles, String myFiles) {
        // Find difference files between the two

        String[] myFilesArr = myFiles.split(Configuracao.FILES_DELIMITER);
        String[] otherFilesArr = otherFiles.split(Configuracao.FILES_DELIMITER);
        List<String> otherFilesList = Arrays.asList(otherFilesArr);
        ArrayList<String> diff = new ArrayList<>(Arrays.asList(myFilesArr));
        diff.removeAll(otherFilesList);

        // Convert back to string
        String diffStr = "";
        for (String f : diff)
            diffStr += f + Configuracao.FILES_DELIMITER;

        return diffStr;
    }
}