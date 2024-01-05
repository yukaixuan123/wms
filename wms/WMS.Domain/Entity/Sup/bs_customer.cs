using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Sup
{
    public class Bs_customer    //客户表
    {
        public int customer_id { get; set; }
        public string cust_code { get; set; }//客户编码
        public string cust_name { get; set; }//客户名称
        public string link_man { get; set; }//收货人
        public string link_tel { get; set; }//联系电话
        public string e_mail { get; set; }//电子邮箱
        public string cust_adr { get; set; }//客户地址
        public string inbill_state { get; set; }//入库状态
        public string cust_from { get; set; }//客户来源
        public string is_del { get; set; }//逻辑删除
        public int finance_id {  get; set; }//银行id
        public string remark {  get; set; }//备注
        public DateTime? opetime {  get; set; }//操作时间
        public string operatoro { get; set; }//操作人
        public string line_type {  get; set; }//所属行业
        public string head_of_Sales {  get; set; }//销售负责人
    }
}
