using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.User;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 权限
    /// </summary>
    internal class AuthorityConfiger : IEntityTypeConfiguration<Authority>
    {
        public void Configure(EntityTypeBuilder<Authority> builder)
        {
            builder.ToTable(nameof(Authority));
            builder.HasKey(e => e.AuthorityID);
            builder.Property(e => e.AuthorityName).IsRequired().HasMaxLength(20);
            builder.Property(e => e.AuthorityAddress).IsRequired(false).HasMaxLength(100);
            builder.Property(e => e.GroupID).IsRequired().HasColumnType("int");
            builder.Property(e => e.Pid).IsRequired().HasColumnType("int");
        }
    }
}
