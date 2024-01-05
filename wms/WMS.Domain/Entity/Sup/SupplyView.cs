using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Sup
{
    public class SupplyView
    {
        [Key]
        public int supply_id { get; set; }//供应商id
        public int finance_id {  get; set; }//银行id
        public string supply_code { get; set; }//供应商编码
        public string supply_name { get; set; }//供应商名称
        public string line_type { get; set; }//所属行业
        public string supply_type_code { get; set; }//供应商分类
        public string link_man { get; set; }//联系人
        public string link_tel { get; set; }//联系时间
        public string e_mail { get; set; }//邮箱
        public string stock_duty_man { get; set; }//进货负责人
        public string inbill_state {  get; set; }//状态
        public string supply_adr { get; set; }//供应商地址
        public string finance_name {  get; set; }//账户名称
        public string tax_no { get; set; }//纳税人识别号
        public string bank_no { get; set; }//银行账户
        public string open_bank { get; set; }//开户银行
        public string open_adr { get; set; }//开户行地址
        public string operatoro { get; set; }//操作人
        public DateTime opetime { get; set; }//操作时间
        public string is_del { get; set; }//逻辑删除
        public string fis_del { get; set; }//银行逻辑删除
        public string remark { get; set; }//备注

    }
}
