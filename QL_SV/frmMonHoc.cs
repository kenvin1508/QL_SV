﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QL_SV
{
    public partial class frmMonHoc : Form
    {
        int vitri = 0;
        bool kt ;
        public frmMonHoc()
        {
            InitializeComponent();
            groupBox1.Enabled = false;
        }

        private void mONHOCBindingNavigatorSaveItem_Click(object sender, EventArgs e)
        {
            this.Validate();
            this.bdsMonHoc.EndEdit();
            this.tableAdapterManager.UpdateAll(this.DS);
        }

        private void frmMonHoc_Load(object sender, EventArgs e)
        {
            DS.EnforceConstraints = false;// tắt ràng buộc khóa ngoại
            this.MONHOCTableAdapter.Connection.ConnectionString = Program.connstr;
            this.MONHOCTableAdapter.Fill(this.DS.MONHOC);
            this.dIEMTableAdapter.Fill(this.DS.DIEM);
            if (Program.mGroup == "KHOA" || Program.mGroup == "USER")
            {
                btnThem.Enabled = false;
                btnXoa.Enabled = false;
                btnPhucHoi.Enabled = false;
                btnHieuChinh.Enabled = false;
                btnGhi.Enabled = false;
            }
            btnPhucHoi.Enabled = false;
            btnGhi.Enabled = false;
            btnTaiLai.Enabled = false;
        }

        private void btnThem_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            vitri = bdsMonHoc.Position;
            bdsMonHoc.AddNew();
            groupBox1.Enabled = true;          
            txtMaMonHoc.Focus();
            kt = false;
            btnThem.Enabled = btnHieuChinh.Enabled = btnXoa.Enabled = btnTaiLai.Enabled = false;
            btnGhi.Enabled = btnPhucHoi.Enabled = true;
        }

        private void btnHieuChinh_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            vitri = bdsMonHoc.Position;
            groupBox1.Enabled = true;
            kt = true;
            btnThem.Enabled = btnHieuChinh.Enabled = btnXoa.Enabled = btnTaiLai.Enabled = false;
            btnGhi.Enabled = btnPhucHoi.Enabled = true;

        }

        private void btnXoa_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            if (MessageBox.Show("Bạn có thật sự muốn xóa môn học này ?? ", "Xác nhận",
                       MessageBoxButtons.OKCancel) == DialogResult.OK)
            {
                try
                {
                    bdsMonHoc.RemoveCurrent(); // xóa tại chỗ 
                    this.MONHOCTableAdapter.Connection.ConnectionString = Program.connstr;
                    this.MONHOCTableAdapter.Update(this.DS.MONHOC); // ghi vào CSDL
                    this.MONHOCTableAdapter.Fill(this.DS.MONHOC);

                }
                catch (Exception ex)
                {
                    MessageBox.Show("Sinh viên đã có điểm môn học này !!! \n\n" + ex.Message, "", MessageBoxButtons.OK);
                    this.MONHOCTableAdapter.Fill(this.DS.MONHOC);
                    return;
                }
            }

            if (bdsMonHoc.Count == 0) btnXoa.Enabled = false;

        }

        private void btnPhucHoi_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            bdsMonHoc.CancelEdit();
            this.MONHOCTableAdapter.Fill(this.DS.MONHOC);
            if (btnThem.Enabled == false) bdsMonHoc.Position = vitri;
            groupBox1.Enabled = false;
            btnThem.Enabled = btnHieuChinh.Enabled = btnXoa.Enabled = btnTaiLai.Enabled = btnThoat.Enabled = true;
            btnGhi.Enabled = btnPhucHoi.Enabled = false;
        }

        private void btnGhi_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            if (txtMaMonHoc.Text.Trim() == "")
            {
                MessageBox.Show("Mã môn học không được thiếu!", "", MessageBoxButtons.OK);
                txtMaMonHoc.Focus();
                return;
            }
            if (txtTenMonHoc.Text.Trim() == "")
            {
                MessageBox.Show("Tên môn học không được thiếu!", "", MessageBoxButtons.OK);
                txtTenMonHoc.Focus();
                return;
            }
            if (kt == false)
            {
                using (SqlConnection con = new SqlConnection(Program.connstr))
                {
                    using (SqlCommand cmd = new SqlCommand("sp_KiemTraMaMonHocTonTai"))
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@MAMH", txtMaMonHoc.Text);
                        con.Open();
                        int success = (int)cmd.ExecuteScalar();
                        if (success == 1)
                        {
                            MessageBox.Show("Mã môn học bị trùng");
                            return;
                        }
                        con.Close();
                    }
                }
            }
          

            try
            {
                bdsMonHoc.EndEdit();
                bdsMonHoc.ResetCurrentItem();
                this.MONHOCTableAdapter.Connection.ConnectionString = Program.connstr;
                this.MONHOCTableAdapter.Update(this.DS.MONHOC);
                this.MONHOCTableAdapter.Fill(this.DS.MONHOC);

            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi ghi môn học .\n" + ex.Message, "", MessageBoxButtons.OK);
                return;
            }
            btnThem.Enabled = btnHieuChinh.Enabled = btnXoa.Enabled = btnTaiLai.Enabled = true;
            btnGhi.Enabled = btnPhucHoi.Enabled = false;

            groupBox1.Enabled = false;
        }

        private void btnTaiLai_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            try
            {
                this.MONHOCTableAdapter.Fill(this.DS.MONHOC);

            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi tải lại :" + ex.Message, "", MessageBoxButtons.OK);
                return;
            }
        }

        private void btnThoat_ItemClick(object sender, DevExpress.XtraBars.ItemClickEventArgs e)
        {
            this.Close();
        }
    }
}
