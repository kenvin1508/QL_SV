namespace QL_SV
{
    using System;
    using System.Data;
    using System.Data.SqlClient;
    using System.Windows.Forms;

    public partial class frmHocPhi : Form
    {
        public frmHocPhi()
        {
            InitializeComponent();
        }

        private void frmHocPhi_Load(object sender, EventArgs e)
        {
            btnGhi.Enabled = false;
            btnTaiLai.Enabled = false;
        }

        private void btnBatDau_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            if (txtMaSV.Text.Equals(""))
            {
                MessageBox.Show("Không được để trống Mã sinh viên", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }
            using (SqlConnection con = new SqlConnection(Program.connstr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetInfoSV"))
                {
                    cmd.Connection = con;
                    con.Open();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@MASV", SqlDbType.Char, 12).Value = txtMaSV.Text;

                    SqlParameter prmt = new SqlParameter();
                    prmt = cmd.Parameters.Add("RETURN_VALUE", SqlDbType.Int);
                    prmt.Direction = ParameterDirection.ReturnValue;
                    cmd.ExecuteNonQuery();
                    int check = (int)cmd.Parameters["return_value"].Value;
                    if (check == 1)
                    {
                        MessageBox.Show("Sinh viên đã nhập không tồn tại !", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                    }
                    con.Close();
                }
            }

            string strLenh = "EXEC sp_GetInfoSV '" + txtMaSV.Text + "'";
            Program.myReader = Program.ExecSqlDataReader(strLenh);
            if (Program.myReader == null) return;
            Program.myReader.Read();
            txtHoTen.Text = Program.myReader.GetString(0);
            txtMaLop.Text = Program.myReader.GetString(1);
            Program.myReader.Close();

            using (SqlConnection con = new SqlConnection(Program.connstr))
            {
                using (SqlCommand cmd = new SqlCommand("sp_GetInfoHpSv"))
                {
                    cmd.Connection = con;
                    con.Open();
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@MASV", SqlDbType.Char, 12).Value = txtMaSV.Text;

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataSet ds = new DataSet();
                    da.Fill(ds, "TableHP");
                    con.Close();
                    dataGridView1.AutoGenerateColumns = true; // hiển thị các cột tương ứng với các trường dữ liệu có sẵn
                    dataGridView1.DataSource = ds;
                    dataGridView1.DataMember = "TableHP";
                    dataGridView1.Columns[0].HeaderText = "Niên khóa";
                    dataGridView1.Columns[1].HeaderText = "Học kỳ";
                    dataGridView1.Columns[2].HeaderText = "Học phí";
                    dataGridView1.Columns[2].DefaultCellStyle.Format = "#,####";
                    dataGridView1.Columns[3].HeaderText = "Số tiền đã đóng";
                    dataGridView1.Columns[3].DefaultCellStyle.Format = "#,####";


                }
            }
            txtMaSV.Enabled = false;
            btnGhi.Enabled = true;
            btnTaiLai.Enabled = true;
            btnBatDau.Enabled = false;
        }

        private void btnTaiLai_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            txtHoTen.Text = "";
            txtMaLop.Text = "";
            txtMaSV.Text = "";
            txtMaSV.Enabled = true;
            btnBatDau.Enabled = true;
            btnGhi.Enabled = false;
            btnTaiLai.Enabled = false;
            dataGridView1.DataSource = null;
            dataGridView1.Columns.Clear();
        }

        private void btnGhi_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {

            using (SqlConnection con = new SqlConnection(Program.connstr))
            {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM HOCPHI where masv='000'", con);
                da.InsertCommand = new SqlCommand("sp_InsertValueHP", con);
                da.InsertCommand.CommandType = CommandType.StoredProcedure;

                da.InsertCommand.Parameters.Add("@MASV", SqlDbType.Char, 12, "masv");
                da.InsertCommand.Parameters.Add("@NIENKHOA", SqlDbType.NVarChar, 50, "nienkhoa");
                da.InsertCommand.Parameters.Add("@HOCKY", SqlDbType.Int, 10, "hocky");
                da.InsertCommand.Parameters.Add("@HOCPHI", SqlDbType.Int, 20, "hocphi");
                da.InsertCommand.Parameters.Add("@SOTIENDADONG", SqlDbType.Int, 20, "SOTIENDADONG");

                DataSet ds = new DataSet();
                da.Fill(ds, "BANGHP");
                for (int i = 0; i < dataGridView1.Rows.Count - 1; i++)
                {
                    dataGridView1.EndEdit();
                    DataRow newRow = ds.Tables["BANGHP"].NewRow();
                    newRow["masv"] = txtMaSV.Text;
                    newRow["nienkhoa"] = dataGridView1.Rows[i].Cells[0].Value;
                    newRow["hocky"] = dataGridView1.Rows[i].Cells[1].Value;
                    newRow["hocphi"] = dataGridView1.Rows[i].Cells[2].Value;
                    newRow["SOTIENDADONG"] = dataGridView1.Rows[i].Cells[3].Value;
                    ds.Tables["BANGHP"].Rows.Add(newRow);
                }

                da.Update(ds, "BANGHP");
                //xóa table dataGridView1 
                dataGridView1.DataSource = null;
                dataGridView1.Columns.Clear();
                con.Close();
            }
            btnGhi.Enabled = false;
            btnBatDau.Enabled = true;
            groupBox1.Enabled = true;
        }

        private void btnThoat_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            this.Close();
        }
        private void dataGridView1_EditingControlShowing(object sender, DataGridViewEditingControlShowingEventArgs e)
        {
            e.Control.KeyPress -= new KeyPressEventHandler(Column1_KeyPress);
            if (dataGridView1.CurrentCell.ColumnIndex == 3) //Desired Column
            {
                TextBox tb = e.Control as TextBox;
                if (tb != null)
                {
                    tb.KeyPress += new KeyPressEventHandler(Column1_KeyPress);
                }
            }
        }

        private void Column1_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar))
            {
                e.Handled = true;
            }
        }
    }
}
