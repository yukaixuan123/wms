using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity
{
    /// <summary>
    /// 审核记录
    /// </summary>
    public class Audit
    {
        public int AuditID { get; set; }
        public string AuditResults { get; set; }
        public string Opinions { get; set; }
        public string AuditUser { get; set; }
        public string AuditTime { get; set; }
    }
}
