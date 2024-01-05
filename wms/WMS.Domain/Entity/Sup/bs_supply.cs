using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Sup
{
    public class Bs_supply  //供应商表
    {
        public int supply_id { get; set; }
        public string supply_code { get; set; }//供应商编号
        public string supply_name { get; set; }//供应商名称
        public string line_type { get; set; }//所属行业
        public string supply_type_code { get;set; }//供应商分类
        public string link_man { get; set; }//收货人
        public string link_tel { get; set;}//联系电话
        public string e_mail { get; set; }//电子邮箱
        public string stock_duty_man { get;set; }//进货负责人
        public string inbill_state { get; set; }//入库状态
        public string supply_adr { get; set; }//供应商地址
        public int finance_id { get; set; }//银行id
        public string operatoro { get; set; }//操作人
        public DateTime? opetime { get; set; }//操作时间
        public string is_del {  get; set; }//逻辑删除
        public string remark {  get; set; }//备注
    }
}
