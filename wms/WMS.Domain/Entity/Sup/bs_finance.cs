using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Sup
{
    public class Bs_finance     //财务表
    {
        public int finance_id { get; set; } //财务ID
        public string finance_name { get; set; }//账户名称
        public string tax_no { get; set; }//纳税人识别账号
        public string bank_no { get;set; }//银行账户
        public string open_bank { get; set; }//开户银行
        public string open_adr { get; set; }//开户行地址
        public string finance_type { get; set; }//业务类型
    }
}
