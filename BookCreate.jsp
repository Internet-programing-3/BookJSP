<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>

<html>
<head>
    <title>���� ���</title>
</head>
<body>
    <center>
        <font color="blue" size="6"><b>[���� ���]</b></font>
        <form method="post" action="BookCreateResult.jsp">
            <table border="2" cellpadding="10" style="font-size:10pt;font-family:���� ���">
               
                <tr>
                    <td>ī�װ��з� :</td>
                    <td>
                        <select name="bookCtg">
                            <option value="����Ʈ����">����Ʈ����</option>
                            <option value="�ű� ����">�ű� ����</option>
                            <option value="���� ����">���� ����</option>
                            <option value="�ؿ� ����">�ؿ� ����</option>
                        </select>
                      	<p>
                    </td>
                </tr>
                <tr>
                    <td>���� ��ȣ :</td>
                    <td><input type="text" name="bookId"></td>
                </tr>
                <tr>
                    <td>���� �� :</td>
                    <td><input type="text" name="bookName"></td>
                </tr>
                <tr>
                    <td>���� ���� :</td>
                    <td><input type="text" name="price"> ��</td>
                </tr>
                <tr>
                    <td>���� :</td>
                    <td><input type="text" name="writer"> ����</td>
                </tr>
                <tr>
                    <td>���ǻ� :</td>
                    <td><input type="text" name="publisher"> </td>
                </tr>
                <tr>
                    <td>�Ǹ� ���� :</td>
                    <td>
                        <input type="radio" name="bookStatus" value="�Ǹ� ��">�Ǹ� ��
                        <input type="radio" name="bookStatus" value="ǰ��">ǰ��
                        <input type="radio" name="bookStatus" value="���԰� ��">���԰� ��
                    </td>
                </tr>
                <tr>
                    <td>�� ���� :</td>
                    <td><textarea name="bookContent" rows="5" cols="30"></textarea></td>
                </tr>
                <tr>
                    <td>������:</td>
                    <td><input type="text" name="bookStock"> ��</td>
                </tr>
                <tr>
                    <td>���� ����:</td>
                    <td><textarea name="bookReview" rows="5" cols="30"></textarea></td>
                </tr>
            </table>
            <p>
            <input type="submit" value="[���� ���]">
            <input type="reset" value="�� ��">
        </form>
    </center>
</body>
</html>
