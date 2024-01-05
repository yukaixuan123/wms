using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Sup;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 客户表
    /// </summary>
    public class Bs_customerConfiger : IEntityTypeConfiguration<Bs_customer>
    {
        public void Configure(EntityTypeBuilder<Bs_customer> builder)
        {
            builder.ToTable(nameof(Bs_customer));
            
                 builder.HasKey(e => e.customer_id);
           
           
            builder.Property(e => e.cust_code).HasColumnType("char(8)").IsRequired();
           
            builder.Property(e => e.cust_name).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.link_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.link_tel).HasMaxLength(30).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.e_mail).HasMaxLength(80).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.cust_adr).HasMaxLength(225).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.inbill_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.cust_from).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.is_del).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.remark).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.operatoro).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.head_of_Sales).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.remark).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.finance_id);
            builder.Property(e => e.opetime).HasColumnType("datetime").IsRequired(false);

       
    }
    }
}
